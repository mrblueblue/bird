defmodule Bird.Parser do

 #  {"li",
 # [{"class", "result-row"}, {"data-pid", "6052134199"},
 #  {"data-repost-of", "5983877095"}],
 # [{"a",
 #   [{"href", "/sfc/apa/6052134199.html"}, {"class", "result-image gallery"},
 #    {"data-ids",
 #     "1:00w0w_4cWLyDSrjzm,1:00U0U_6mPQphOHOO2,1:00S0S_d45pXj58XET,1:00M0M_1LtXe68hoTF,1:00303_iglMr8nIelb,1:00f0f_f6zMT8C7vNM,1:00000_9h8HrsElwwH,1:00y0y_hDoaaux9cxg,1:00y0y_4FS5RvkJo7d,1:00R0R_5Ace41hxugg,1:00o0o_kqHO7b4Cz8k,1:00E0E_bzhVDROz5vS"}],
 #   [{"span", [{"class", "result-price"}], ["$2895"]}]},
 #  {"p", [{"class", "result-info"}],
 #   [{"span", [{"class", "icon icon-star"}, {"role", "button"}],
 #     [{"span", [{"class", "screen-reader-text"}], ["favorite this post"]}]},
 #    {"time",
 #     [{"class", "result-date"}, {"datetime", "2017-03-21 17:26"},
 #      {"title", "Tue 21 Mar 05:26:29 PM"}], ["Mar 21"]},
 #    {"a",
 #     [{"href", "/sfc/apa/6052134199.html"}, {"data-id", "6052134199"},
 #      {"class", "result-title hdrlnk"}],
 #     ["20th Street & Capp/Available Now/Pets Ok!City Views! $0 Deposit!"]},
 #    {"span", [{"class", "result-meta"}],
 #     [{"span", [{"class", "result-price"}], ["$2895"]},
 #      {"span", [{"class", "housing"}],
 #       ["\n                    1br -\n                "]},
 #      {"span", [{"class", "result-hood"}], [" (mission district)"]},
 #      {"span", [{"class", "result-tags"}],
 #       ["\n                    pic\n                    ",
 #        {"span", [{"class", "maptag"}, {"data-pid", "6052134199"}], ["map"]}]},
 #      {"span", [{"class", "banish icon icon-trash"}, {"role", "button"}],
 #       [{"span", [{"class", "screen-reader-text"}], ["hide this posting"]}]},
 #      {"span",
 #       [{"class", "unbanish icon icon-trash red"}, {"role", "button"},
 #        {"aria-hidden", "true"}], []},
 #      {"a", [{"href", "#"}, {"class", "restore-link"}],
 #       [{"span", [{"class", "restore-narrow-text"}], ["restore"]},
 #        {"span", [{"class", "restore-wide-text"}],
 #         ["restore this posting"]}]}]}]}]}

  @url "https://sfbay.craigslist.org"

  defp toListing(row) do
    %{
      title: Floki.find(row, ".result-title") |> Floki.text,
      price: Floki.find(row, ".result-meta .result-price") |> Floki.text,
      link: Floki.attribute(row, ".result-title", "href"),
      neighborhood: Floki.find(row, ".result-hood") |> Floki.text
    }
  end

  def parse(html) do
    Floki.find(html, ".result-row")
      |> (fn(n) -> Enum.map(n, fn(a) -> toListing a end) end).()
      |> IO.inspect
    # |> Floki.text
    # |> (fn(n) -> %{first: "hello", text: n} end).()
    # |> (fn(n) -> IO.puts n.text end).()
  end
end
