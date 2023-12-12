class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.23.tar.gz"
  sha256 "0978b1e169a022b356c5a4e048724732ba63ea82e0654310b6738bf08c6269ad"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29685461ca778a752dfd3f1d3bd3f1f3569d80a0d6252966c3b9868c09d73e13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b071ce8a9ea2b5e064b737fd53d234774d25c56109928c0161757af776fc678b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa36a96c1332cc95da623936555beb589de2c1ccdaa1c5a7dc03f43d11fbf9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbcdd5af9cfeaf748e451ffe524c19f67962e2c203bb38c3f199349f76e2111b"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d464fe66ce0e32b54086722a4a0a764db24df6544552c1bccb7a7c1b678699"
    sha256 cellar: :any_skip_relocation, monterey:       "30f1d819743af14ba2e30ca26f9ff04a36e863ff62cd5b295acca8431c925402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54681e324c7a20d043e139111085187ce81d2a4495d3173516dc36adcfc595d6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end