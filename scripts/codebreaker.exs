defmodule Codebreaker do
  @behaviour Problem
  alias Types.Chromosome
  import Bitwise

  def genotype do
    genes = for _ <- 1..64, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 64}
  end

  def fitness_function(chromosome) do
    target = "ILoveGeneticAlgorithms"
    encrypted = "LIjs`B`k`qlfDibjwlqmhv"
    cipher = fn word, key ->
      word
      |> Enum.map(&Bitwise.bxor(&1, key) |> rem(32768))
    end

    key =
      chromosome.genes
      |> Enum.map(& Integer.to_string(&1))
      |> Enum.join("")
      |> String.to_integer(2)

    guess = List.to_string(cipher.(encrypted, key))
    String.jaro_distance(target, guess)
  end

  def terminate?(population, _generation) do
    Enum.max_by(population, &Codebreaker.fitness_function/1).fitness == 1.0
  end
end

soln = Genetic.run(Codebreaker, crossover_type: &Toolbox.Crossover.single_point/2)

{key, ""} =
  soln.genes
  |> Enum.map(& Integer.to_string(&1))
  |> Enum.join("")
  |> Integer.parse(2)

IO.write "\nThe key is: #{key}\n"
