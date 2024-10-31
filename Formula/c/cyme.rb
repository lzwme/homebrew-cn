class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv2.1.0.tar.gz"
  sha256 "cd6955a847e27698ebc086cb2270e51e4367f47769321c1ae6bb3ad8c1d28cfd"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c701624fe101a27fb96f0136f48f25ebb671091ff3ab86010b25679098419e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27cc02abd006b1b49b6921d40d39d5d3b4091bb07383679af3713b8266f9abeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65b47ef35162cf21bab557424957675f7a5e60cc8a50e08a2421a2efaebc9c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d0bbd3e18f6877c52d1fd928d1d623a9dac07e4800594e50fa0ee5f1bfffd96"
    sha256 cellar: :any_skip_relocation, ventura:       "36671f19973d27b191734987749ce2422b0896317ff42e016528cc22ca6f0a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdbfb53df50eb582d3d4d9a6b220a8a68337ff7f0de287d65b87e0dff85ffe10"
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