class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://ghfast.top/https://github.com/datastax/astra-cli/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c9caeb332381ec2de0723036ee8f3e266b89634fcae13396400590d781a97637"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ce67b664941e3055fdd1359c5e03dabcef6d683cf5b1744a2bec57caa0b5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d6c285db4ae2faee015db871a32e2c4f75432ba2e71d808295ecdd1284e2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa7ec69950ad1b27c169a0e326b96432320623a76bcd0b108c4270defae4f88"
    sha256 cellar: :any,                 arm64_linux:   "5820c76a74f47a63a1234b332750267cd98b7fcecbb9387c26b02f4204209c43"
    sha256 cellar: :any,                 x86_64_linux:  "7b178c44ca9552fb032c3fa359d513c2758a1d64090436623bf9688051bcf42e"
  end

  depends_on "graalvm" => :build
  depends_on "gradle" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      formula_opt_libexec("graalvm")/"graalvm.jdk/Contents/Home"
    else
      formula_opt_libexec("graalvm")
    end

    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    (buildpath/"src/main/resources/static.properties").append_lines "cli.via-brew=true"
    system "gradle", "nativeCompile", "-Pprod", "--exclude-task", "test", "--no-daemon"

    bin.install "build/native/nativeCompile/astra"

    generate_completions_from_executable bin/"astra", "compgen", shell_parameter_format: :none, shells: [:bash, :zsh]
  end

  test do
    ENV["ASTRARC"] = "/a/b/c"
    ENV["ASTRA_HOME"] = testpath
    assert_equal "/a/b/c",
      shell_output("#{bin}/astra config path -p").strip

    ENV["ASTRARC"] = "/x/y/z"
    assert_match "Error: The default configuration file (/x/y/z) does not exist.",
      shell_output("#{bin}/astra db list 2>&1", 2)

    assert_match "DbNamesCompletion_arr",
      shell_output("#{bin}/astra compgen")
  end
end