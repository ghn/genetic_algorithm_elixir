defmodule Toolbox.Crossover do
  alias Types.Chromosome

  def order_one(p1, p2) do
    lim = Enum.count(p1.genes) - 1

    # Get random range
    {i1, i2} =
      [:rand.uniform(lim), :rand.uniform(lim)]
      |> Enum.sort
      |> List.to_tuple

    # p2 contribution
    slice1 = Enum.slice(p1.genes, i1..i2)
    slide1_set = MapSet.new(slice1)
    p2_contrib = Enum.reject(p2.genes, &MapSet.member?(slide1_set, &1))
    {head1, tail1} = Enum.split(p2_contrib, i1)

    # p1 contribution
    slice2 = Enum.slice(p2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    p1_contrib = Enum.reject(p1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(p1_contrib, i1)

    # Make and return
    {c1, c2} = {head1 ++ slice1 ++ tail1, head2 ++ slice2 ++ tail2}

    {
      %Chromosome{
        genes: c1,
        size: p1.size
      },
      %Chromosome{
        genes: c2,
        size: p2.size
      }
    }
  end

  def single_point(p1, p2) do
    cx_point = :rand.uniform(length(p1.genes))
    {{h1, t1}, {h2, t2}} =
      {
        Enum.split(p1.genes, cx_point),
        Enum.split(p2.genes, cx_point)
      }

    {c1, c2} =
      {
        %Chromosome{p1 | genes: h1 ++ t2},
        %Chromosome{p2 | genes: h2 ++ t1}
      }
  end
end
