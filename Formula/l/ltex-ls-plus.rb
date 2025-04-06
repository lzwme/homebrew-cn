class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https:ltex-plus.github.ioltex-plus"
  url "https:github.comltex-plusltex-ls-plusarchiverefstags18.5.0.tar.gz"
  sha256 "5c5c4675644eff6c665f799d07c266360959b070ecfa0a310410b03846029583"
  license "MPL-2.0"
  head "https:github.comltex-plusltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e56206be9f578c17a0020186ee9473b990b8b8b81891f59dc6358c976bb29eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ea13411633b9616f6e2e6ac5c5b75e0a174e474e161308a6f92696f034bfbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0291c8194687e06e0bb1fc496b26bddf34676e9a590a0f99619a249280cb5c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ce518020bf309203fae9806d60b6872ea5e8fbe1d8a6ecfe2a86bd4e225ef7"
    sha256 cellar: :any_skip_relocation, ventura:       "20cf4c0d97edcd066edfc3b0880463370a6c48ee7504da7ac3e229a36243e3d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2497b148cb3c3e6e3d6254c9b6a5951c674f9a8676381dce17cd7925606551dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7e524212da82fb51846a8f0895bdcfd6657f267c51cb9fed7f0218bd119bf5"
  end

  depends_on "maven" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https:github.comvalentjnltex-lsissues244.
    inreplace "pom.xml", "<arg>-Werror<arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system "python3.13", "-u", "toolscreateCompletionLists.py"

    system "mvn", "-B", "-e", "-DskipTests", "package"

    mkdir "build" do
      system "tar", "xzf", "..targetltex-ls-plus-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-plus#{version}bin*.bat"]
      bin.install Dir["ltex-ls-plus-#{version}bin*"]
      libexec.install Dir["ltex-ls-plus-#{version}*"]
    end

    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath"test").write <<~EOS
      She say wrong.
    EOS

    (testpath"expected").write <<~EOS
      #{testpath}test:1:5: info: The pronoun 'She' is usually used with a third-person or a past tense verb. [HE_VERB_AGR]
      She say wrong.
          Use 'says'
          Use 'said'
    EOS

    got = shell_output("#{bin}ltex-cli-plus '#{testpath}test'", 3)
    assert_equal (testpath"expected").read, got
  end
end