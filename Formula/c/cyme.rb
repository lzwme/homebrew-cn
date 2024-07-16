class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv1.8.0.tar.gz"
  sha256 "e0da391876423afc6dd318f85d7a371924773c07fd412daad925c2e05512c69b"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bebcb18b356e3dc757b36c9eeb10a490032a79fe37b1ec93dbe1ab9835b90929"
    sha256 cellar: :any,                 arm64_ventura:  "9ecab833277b536f6ea97571ddfda7c29b7d6976edd3a353eed11f44c7ea4f71"
    sha256 cellar: :any,                 arm64_monterey: "69e08783c9971f23e35d0262fafcd6cb4fa08d92c58c682e511ea9164458c935"
    sha256 cellar: :any,                 sonoma:         "150518b72067211d80dde72ace954f84ab3335f26f1f4f41ac5f19f7b15c72d6"
    sha256 cellar: :any,                 ventura:        "6c9861f87e8e3b639f21da72250cf3df6f74a9d6e9d3392c4768c3ff4cf1a7d2"
    sha256 cellar: :any,                 monterey:       "4f029d6981dc78cd6bceb1593e35443caa76bbac49cebe2c6c1b3e2ef9a10c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0622efb4b67dd74dfa436b7fdb45976a608aaf87a305636415da680bf96b19d5"
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