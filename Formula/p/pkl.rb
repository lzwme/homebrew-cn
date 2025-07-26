class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://ghfast.top/https://github.com/apple/pkl/archive/refs/tags/0.29.0.tar.gz"
  sha256 "bbab5066f7d29187ac4fe48e935c96b2f27fc178d5d93193862dff7ac47896d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b10508d8ce0bf9a09d433faeb38b6754fe671c38eb668ebefe1e6ecd1cdac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b095130d03939adc618aab9e260c0ccd0c7f07105019a91fe3f0d8d9e73942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab3f6e4a26ccbea0c28ed2ba4d5e1f3748b9e147fe028bef6fb868dbc3946f39"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc57bf57d1cae9c05727524fc1839e5093b633ba1f81069f0e514d2c874de94a"
    sha256 cellar: :any_skip_relocation, ventura:       "a0afb94ca2a6f02168ee06cf93307d431ae2b3f149fa63a2369cdb6a94eb1cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f9e1770956ddd2c2a88dacc4bbd8ff50fd7a91fd8c209ba86a7f0c72c9910b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5fb22efc4ba5f9d62e53b29c3b2fecd22a127358250be1fca34013afbd510c4"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "pkl-cli:#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end