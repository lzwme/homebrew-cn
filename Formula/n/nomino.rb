class Nomino < Formula
  desc "Batch rename utility"
  homepage "https:github.comyaa110nomino"
  url "https:github.comyaa110nominoarchiverefstags1.3.7.tar.gz"
  sha256 "9c19028b9e685976e9196c0c769c3690f0b56ff1f61f4f6a06ab6a32b163a6a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyaa110nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a5ba7ef4602dcd4944b78df2846e8e3a685a62734f501fc4e4af1a9a7cc6270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902f9d3471406bbc225d2270112e38da7ddc31b6005ba5e51c0a6a4446a71a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a927ff74a7687f8a0782ca9df0518cebde1d68b55490ce3f0e49f1c089c8fea"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe3be11e90efe67671aa0bcbedda930ec6384b469ed36335e6215cce01ce041"
    sha256 cellar: :any_skip_relocation, ventura:       "8bbeeed3cf80e42a6722d933434462824520819a2f8a8b5043f1cf0214fefd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c858accd5a19e9436c4c45bb1bbb93abe639d8561c5302dd0f92bace2a4836"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath"Homebrew-#{n}.txt").write n.to_s
    end

    system bin"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath"#{n}.txt").read
      refute_predicate testpath"Homebrew-#{n}.txt", :exist?
    end
  end
end