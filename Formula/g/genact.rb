class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https:github.comsvenstarogenact"
  url "https:github.comsvenstarogenactarchiverefstagsv1.3.0.tar.gz"
  sha256 "79e1c4173757ddbf3b6878ae83d09905ea7c38d5366aa08a50e96e566cd12478"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc054182941bf0eb432336635520990d1946f6e0299a007ce64d0858d4cfec92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae19acb6250d39fc4f232c159e7125201c26cf860131249a68b287d1a18eb126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb5f0abbe0ef04bac96ac06135ba791a98512b334e7869531b9d151f9e99c0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "687568417d4e502f5dd9e058bef214904b07e9223e692f770c282f467cb2556b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e1a259f5f1f60c2df0b48273c528dfdf40a8bdaa9ccfb7c9fdba1c21686fc1f"
    sha256 cellar: :any_skip_relocation, monterey:       "080663c9ce9edcb2e34c841c8450bb845f8834e7393a61204a1fc8b368e82a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e0efc7cbdfd7379c93bd5e1656aeb97aad1c1f19e57a48454cd04762be2fc7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}genact --list-modules")
  end
end