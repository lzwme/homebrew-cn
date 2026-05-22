class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.2.tar.gz"
  sha256 "bb86b692dd407dab89abe9b0f8caa34578c126d81673829b656815b81fdfedfa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9780e904b1dbf3592674a68b03d0ee0e65c926616b17f43c5d7bf248d19533d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eae6283f93a7e95ba7f238b9ab94baaf5617515b0f2ed4e4ae9d5bfd1a48d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75715715e2b9231f475b9a33aee76e23e75b190613ccbe4890afe0511051c0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4977b653995fb03c953662f806987a15907d15acd718af1e0963165995e2aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25984ee1163f29d0696c57626046d5656830080beab02fb4af52e256e6dcbd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7959591353fc96d523dc2762136df6875a1c5e7de6febab193faece45f3546"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"hello.nf").write <<~EOS
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
    EOS

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end