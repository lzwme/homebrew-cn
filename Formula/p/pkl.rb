class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://ghfast.top/https://github.com/apple/pkl/archive/refs/tags/0.29.0.tar.gz"
  sha256 "bbab5066f7d29187ac4fe48e935c96b2f27fc178d5d93193862dff7ac47896d9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6ce6ea80fab6b7c066e06e63613f4b53a2fef709ef7b8111a1e3cfad5f6ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9135ce3476dad9d55bb49f2dcaba2a27b810280a7107f22ab4191a3fac6ac2ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66234b9765b70dc41eef01fb02af8275c7c80bc1d3825688e0574f248884ea31"
    sha256 cellar: :any_skip_relocation, sonoma:        "cade7519cf009b3231cd8bc8305a48f17477742df0ed8057bca2e1c80dfe99db"
    sha256 cellar: :any_skip_relocation, ventura:       "dd247654b3e03a76fa269bef790656edfad9d5e3cf976867b1eef47413a9d58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d30d56d4754534faeecac8baee8da7046405d02d8080b7ed3ce8e0550f6f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f4da375191a4cc760f33bdb269faf93052d2d6de4cd23734fa719c9fef9c8d"
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
    generate_completions_from_executable(bin/"pkl", "shell-completion")
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end