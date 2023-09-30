class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.9.2.tar.gz"
  sha256 "ed4bc7910802814d7570f4b9950825740a6096b32d9a706f7077f11e03380432"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8eff3bdb62394f0f84390dd4986d9a827c07ce1584f83961f88900cdac39346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d91eb2d3e52ea0d1243a403248e13328fde527a32e2207d2df8e682ce2c1ed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b065ebfc829b520778b632db5c942d9b522a741d96acf0b99611a57352210c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "14d54c5adc7306d00301425b3054c91669f7a4c2689a95daf97d2ade33723b34"
    sha256 cellar: :any_skip_relocation, ventura:        "62364fe3ec0a5bb104f9d0244d0d56859f4dc751543118874ec43d18a999679d"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb9eb90881fa20b603ad4d080e97cf6d478f6e17b2b3ecda558a1b5bab07bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9152da2aa8e52cd76b49723fea2908102741cf2d418b58edc8c22949d4a1794"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end