class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https:github.combootandydust"
  url "https:github.combootandydustarchiverefstagsv1.2.1.tar.gz"
  sha256 "d8ac1a78287a9ea9e6a0e350886dbef8902f5f1dcba9bbc25afafe2ed2ca0a95"
  license "Apache-2.0"
  head "https:github.combootandydust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff30219a60289dcbcde2884f80a05507c232ddfc825cedffa13842a4e4ec799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e445a4090bbfa559c2b44fd26f4ca4a67b5614efa1ef7b546419cce2bd423171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94d7efb52c0ab5b2066f66697b17e0230590243a8f9602f0e645e2cc8de4c2c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3653e40df944f053ebb6810157d488775049d7f96573d243678b83ed75cd5a3d"
    sha256 cellar: :any_skip_relocation, ventura:       "16dbab4f1ba9eed3939dfe37b28b7660d18f0d3dc78bd567c718d28dbaba669f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da3b69309c776eaf8e034b0722fc83be2c03e465be71c039ab6d5a05dff33d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c65641f9278aeb2ce3434b748e780d02ba6dbeca5a73620e750336e644685348"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsdust.bash" => "dust"
    fish_completion.install "completionsdust.fish"
    zsh_completion.install "completions_dust"

    man1.install "man-pagedust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https:github.comHomebrewhomebrew-corepull121789#issuecomment-1407749790
    if OS.linux?
      system bin"dust", "-n", "1"
    else
      assert_match(\d+.+?\., shell_output("#{bin}dust -n 1"))
    end
  end
end