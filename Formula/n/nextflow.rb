class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.6.tar.gz"
  sha256 "e0891da76f2e17336eaeadac14971a7e69cdc07722d44b605489c4dc6718d6a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7639b6a849dd151ccc378fd753016d757fbcd433e02279327d18dccc0a6961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9d42f665a30a6a3d19a2ccccef2eef498450762091294f746482a5310670e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a0822a5b9e0ecdf061ee32f1e04ef079a8917b4a6d0e5556cc44619c1e4982"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb94ac800c2edb004de5fe9a76007356c9b64504026fdb9669a656d5b7f9b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "e006b164228bdab66ec70019f56fbc936217f0208960e33b8c52c40817effe02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a156caeba1d209af940b9b874ff1b9c95c16e0b6081c2849af80cdc5626d650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54c5600ff39d4d73ca33d62b2f4d4e19401e788f8e268ad727823d61451af8d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    # update Foojay plugin for gradle 9 compatibility, upstream pr ref, https://github.com/nextflow-io/nextflow/pull/6388
    inreplace "settings.gradle", "0.7.0", "1.0.0"

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