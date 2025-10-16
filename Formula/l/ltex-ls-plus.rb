class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://ghfast.top/https://github.com/ltex-plus/ltex-ls-plus/archive/refs/tags/18.6.0.tar.gz"
  sha256 "3efdd627a4ab26d01cb393f49902ee9f2136d84595587887432a9752f41981c6"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4dda7ef789728f2c0a4ed55d97012617394e459f1857cadb57407572432d6e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b2f6f5c5801de35d3027541626beaddf6126aad3ceeae2b49e1788268cb83a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5995f3c310109c28dfb51f7c81b132adbf97f4e24692dfc675bd31fbdcd079e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d12c2b0277e63178bb5bf37d15da73f0d3971a311dcfb9563a9dcf87c251ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13581fb600680de6b9151addcf4f15daabbb23bba8aca9d7b9e99a14fdb60de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320b6f491ee556201e8c31fdffb42077a0e657d41d63cc6283ce7ddcec1ec724"
  end

  depends_on "maven" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system "python3.14", "-u", "tools/createCompletionLists.py"

    system "mvn", "-B", "-e", "-DskipTests", "package"

    mkdir "build" do
      system "tar", "xzf", "../target/ltex-ls-plus-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-plus#{version}/bin/*.bat"]
      bin.install Dir["ltex-ls-plus-#{version}/bin/*"]
      libexec.install Dir["ltex-ls-plus-#{version}/*"]
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test").write <<~EOS
      She say wrong.
    EOS

    (testpath/"expected").write <<~EOS
      #{testpath}/test:1:5: info: The pronoun 'She' is usually used with a third-person or a past tense verb. [HE_VERB_AGR]
      She say wrong.
          Use 'says'
          Use 'said'
    EOS

    got = shell_output("#{bin}/ltex-cli-plus '#{testpath}/test'", 3)
    assert_equal (testpath/"expected").read, got
  end
end