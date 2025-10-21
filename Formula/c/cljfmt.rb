class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.14.1.tar.gz"
  sha256 "e6eb781b096bf471f82dc6b7a7dfa2889515ca83634b6dda9cbb47df605c5ef9"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f6a1735587270aa1baad9f239611ecbccb486fc29ac5adf426434792f45233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6dbcc7caebf31ef99ec40d85d67cff539d6fe4406c40eed5b07c2190c24f2ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b16dabc45835086d6f3918af835f762d7c7a6053b04c610cf03619cf9f9d351"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e4aca6cb2f03a336b5d92f4b7d4978e5e4c57889b9622b141a513ad31e0454b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d52e8f1e7e459330c330252e61fe20fc72871892a927dc4e70baf997882ee36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edb5fefe18c909a50be6cafae030eecdbbf5073457931c6a483fe093bb5a6097"
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