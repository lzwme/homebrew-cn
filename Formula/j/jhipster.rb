class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-9.3.0.tgz"
  sha256 "d827aced52b59e50573c4c2f5d24a0bd6d875e1f0b4942c1437f4f1c9da6c412"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5856e22bd2c68421150250215584f9a431102bd5c88bf7923ffd7441986ff381"
    sha256 cellar: :any,                 arm64_tahoe:       "da539c1fa54eb73f1524e1b16ab3bc993927a42e4cf0593882c8cf966254ba74"
    sha256 cellar: :any,                 arm64_sequoia:     "da539c1fa54eb73f1524e1b16ab3bc993927a42e4cf0593882c8cf966254ba74"
    sha256 cellar: :any,                 arm64_sonoma:      "da539c1fa54eb73f1524e1b16ab3bc993927a42e4cf0593882c8cf966254ba74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c232e2a27fd279ac144bd9070670f8d70d2d55bd91402e36e4e7e1bafa5d08ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ef37dbc6cea836c7bcfe14d2cee71d38bf730ca7b13e3dcdd43fde2136ac6a2a"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end