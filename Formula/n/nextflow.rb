class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.2.tar.gz"
  sha256 "496c91400a0757f2173b6baac0365303c9404d2ec515544e639015ddb55d9d91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25ab34b9dedbad1427e46bd133899203b88fdf8f83c3de7c741f0e0eaf24118f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f6b7bd59a6e9fa9fe81ceb9ca54d219faa8c6665df91c09922d707be863e4f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "391dd19e0a6a59ae56768e6fab328ecf3b2dfc6ea642aa5bbdcbb55bb82565d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3160047ae38e561d94f0003761a5fa3af26b98c7794738c1394d824e8ccc5c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "07132b7121ac2cf58390692e34e9068e5b42ef00283906c022cb15d24c9ed723"
  end

  depends_on "gradle" => :build
  # TODO: Switch back to `openjdk` once Nextflow supports JDK 27: 26.04.6 documents
  # "Java 17 (or later, up to 26)" and fails with "Unsupported class file major version 71".
  # https://www.nextflow.io/docs/latest/install.html#requirements
  depends_on "openjdk@25"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env("25")
  end

  test do
    (testpath/"hello.nf").write <<~NF
      process hello {
        publishDir "results", mode: "copy"

        output:
        path "hello.txt"

        script:
        """
        echo 'Hello!' > hello.txt
        """
      }
      workflow {
        hello()
      }
    NF

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end