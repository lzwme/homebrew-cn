class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.7.3.tgz"
  sha256 "285766032938db33d93d7083c1789f291516d31ebdfa95229f5a9c7f83e26104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e32fe7d0d2d3818f587fe9fa78cf2f147e4cd48b9d7354215a45d1521ccc3b38"
    sha256 cellar: :any,                 arm64_sonoma:  "e32fe7d0d2d3818f587fe9fa78cf2f147e4cd48b9d7354215a45d1521ccc3b38"
    sha256 cellar: :any,                 arm64_ventura: "e32fe7d0d2d3818f587fe9fa78cf2f147e4cd48b9d7354215a45d1521ccc3b38"
    sha256 cellar: :any,                 sonoma:        "28110892202bd4cda14eb5409b06db13c34b3e13e8e5d594866de2e4e38e517b"
    sha256 cellar: :any,                 ventura:       "28110892202bd4cda14eb5409b06db13c34b3e13e8e5d594866de2e4e38e517b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a301fa2e1f71f73104071694be490cece2b5aa37aaf99236e3d60a78ea1841b"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end