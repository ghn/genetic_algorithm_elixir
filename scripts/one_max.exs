defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl True
  def genotype do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl True
  def fitness_function(chromosome), do: Enum.sum(chromosome.genes)

  @impl True
  def terminate?([best | _]), do: best.fitness == 42
end

soln = Genetic.run(OneMax)

IO.write("\n")
IO.inspect(soln)
