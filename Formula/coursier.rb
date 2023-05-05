class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://ghproxy.com/https://github.com/coursier/coursier/releases/download/v2.1.3/coursier.jar"
  sha256 "145a975dfee6d78f7e7814c530a25cbe7d6b221003e3ea50d1fc5894973b348c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-M\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fbf0e1227ac044f5801492da2d5e91909b27dd80048be21384edd9c5185dc90"
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