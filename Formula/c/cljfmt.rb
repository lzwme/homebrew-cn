class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.3.tar.gz"
  sha256 "b40ef8ccd0bb64fcda56b28c043d995c772b391ec0b605bc1e0bb7ef64df1f10"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "424546f6441f0834947fa5568d85106db9878f7264f2bb5d8a6abd821fbae7d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc27186eb7a97f8504db70784b617237ce1759d36104418c2229ba5b08d226d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065cae91b219fe64fc8e9ce4a44727e4499b1d57c7d95b5e9ba47661f81fd63d"
    sha256 cellar: :any_skip_relocation, sonoma:        "176c32a079c0641b79feb7d16b5d5880df3ad4c7c6c16a960759dd7a73a6f3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da9f2ff77a62b11fdc298538599f17f5210dfe72537b6f76392d6f7f8a21889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90853940705e21ad035433f25c774c6123607aa8b9afc170655691575f8a0bed"
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