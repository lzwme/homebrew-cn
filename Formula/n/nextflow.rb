class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.1.tar.gz"
  sha256 "d658b7c9ec93b0e9eeaea28897497b77c99b08287c5afbe35e7968c3bd01358d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd03c4cca036ad13f1e010d416ea0dfb0b153d1254e68a8448d61b22d3f445ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c64540f325c43848d6043c4e51ba0a099342c37016925d4a1b321ec479771b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76a0d05b766be89447f5e795e573bcabd7c2bec2147a365b74262b5567e34c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df7096af2b1c8c274b57c1b4c5794074ff698889c95a07f26e7acdeee70469c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "42e1986283c620bf477dd4aca9bf1dc23d4676a816b3d386faf721730c1cd03a"
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