class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://ghfast.top/https://github.com/apple/pkl/archive/refs/tags/0.30.1.tar.gz"
  sha256 "9f5d1b29d5c43a52b0a52f345f9e4cfaa1566b935e5f4b4f2348dd91f437deef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6da0fadaa118d0aff41b9b6d150b66ca66708da93d7e8dd2ccc4df3a0a1c3f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3a39b09615c1c94761303714786dae1347cb827163f26cfb21b2406b8b7191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29675d155269cdbfb74717894c93d3a37cf4dc28882dc593bd8c509e041c2abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd675dc926af5dc9697fbc954fc9eff9689952c9731ca1ec0f05f7568f7d417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97ccdce3d329bfbd5a5154515bd5c1a253059b21cfba066b10d7b525fb5a962b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c8172cdf23c4ca49343fd68550fb9f90264f08fb16e795c1043df78055500f"
  end

  depends_on "gradle@8" => :build
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
    generate_completions_from_executable(bin/"pkl", "shell-completion")
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end