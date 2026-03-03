class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.1.tar.gz"
  sha256 "bf0f4268c27523fe0149ecb3da2db6d663f0b87b731588bd4843b25482445846"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d68c03bf847700604730bb14f17218999e75cb547ec31c5f74d98b9ced8b0e01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3be2fc4b06e7a72c98b66b7fbef6c3dee9430bfb8a821d8b67a2a642fc542c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527c1d32d7aa93240553af969ca87a54679ff7424a9798fbaf22a07a981ab25c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e037cc03c871ce1be5abbf3b386c2a780621eaa4db2dea3320ae05b2af049c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8483863455fc642606419a1638f7f4c019510aaa7ca4e1a84b210fc8c707673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd854302d3f14a5c4d7e1bf6d6749c25cb9e1515599a3bd17542e86a4e7a003a"
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