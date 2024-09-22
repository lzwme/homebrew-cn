class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv1.8.3.tar.gz"
  sha256 "4c69e0bd843b01781bb36ad1384f59430550eb87227283414e654a014c0cdec4"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eb737cc24d7f378dd45aad183f73a965b8330ff8e7fb6e71803304725a17d5c"
    sha256 cellar: :any,                 arm64_sonoma:  "31e6906117280f3f7bfedcad135033baf00907eb73ba2a1d3482805231233e58"
    sha256 cellar: :any,                 arm64_ventura: "73fd7625ef23ffdc562284e42bbd5f3dd7d441eac92ebf8197d443d62a5dc4a4"
    sha256 cellar: :any,                 sonoma:        "8defb8b6a226d8b56f2d33cc4049caf12234f21060c5a36fbad7574fbe1280b9"
    sha256 cellar: :any,                 ventura:       "d63f212f2c459385af147325d035177ce386d482f845e785762b07f2cd6d9413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0fa41000bcadf0f57ff07eeb2bd6c8c71998333ed854107e99deb46da4dbcb8"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doccyme.1"
    bash_completion.install "doccyme.bash"
    zsh_completion.install "doc_cyme"
    fish_completion.install "doccyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end