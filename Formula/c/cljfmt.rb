class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.4.tar.gz"
  sha256 "eac1cc6b7649c6b02f4ccb3c84c3f6bb174010cd40faef9fa5dd7e3e8515988c"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe877c1132b6a86b24a7963ac504a478c734610dd7c6998445cc4ac41b980387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c662bc7a110fb8ad3687a14cf07473fdb1e268855ae4da68433dc284fe2a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b604f9b9ced751abe2e5c7f1f6e7c9b14f70a34cbcad0b8258f5e51585c7fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "efcb4e0154280edff75b38beca55d293168ddac8c3141d8679a4b0068b730bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d346447e454c79cd0f30ee191aed314f673c03bdaf03b8e7fcae9852a431bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8b3af0391779a1375edfd3aca1391476496c1f37f07e3d6804cf76867b71f1"
  end

  depends_on "leiningen" => :build
  depends_on "openjdk"

  def install
    cd "cljfmt" do
      system "lein", "uberjar"
      libexec.install "target/cljfmt-#{version}-standalone.jar" => "cljfmt.jar"
    end

    bin.write_jar_script libexec/"cljfmt.jar", "cljfmt"
  end

  test do
    (testpath/"test.clj").write <<~CLOJURE
      (ns test.core)
        (defn foo [] (println "hello"))
    CLOJURE

    system bin/"cljfmt", "fix", "--verbose", "test.clj"

    assert_equal <<~CLOJURE, (testpath/"test.clj").read
      (ns test.core)
      (defn foo [] (println "hello"))
    CLOJURE

    system bin/"cljfmt", "check", "test.clj"

    assert_match version.to_s, shell_output("#{bin}/cljfmt --version")
  end
end