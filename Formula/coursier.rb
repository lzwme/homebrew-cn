class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://ghproxy.com/https://github.com/coursier/coursier/releases/download/v2.1.1/coursier.jar"
  sha256 "14158f5e0a70d5a395a9d29c7d210ea4182a9c3425835779938f9db0f4e12e13"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-M\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99091bc2a6f9117a0652598efe91431c3a52adac8cfa431e783d2d1f4ff471d9"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "coursier.jar"
    chmod 0755, libexec/"bin/coursier.jar"
    (bin/"coursier").write_env_script libexec/"bin/coursier.jar", Language::Java.overridable_java_home_env

    generate_completions_from_executable("bash", "#{bin}/coursier", "completions", "bash",
                                         shell_parameter_format: :none, shells: [:bash])
    generate_completions_from_executable("bash", "#{bin}/coursier", "completions", "zsh",
                                         shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    system bin/"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}/coursier search scalafix")
  end
end