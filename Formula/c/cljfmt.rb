class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.2.tar.gz"
  sha256 "6512a9c4e6399b1a21bbcadb1c001599cc00fc0d4b5c28edd19110e8a9c15343"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15706165e4c5540160750ff74fda9b790f10dca3a0c4860c1142b66a144a5018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecc10296a422d52e028d13645bca3ab88a9ac2738e17da9c95f9c2123b9a6525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85796c8793e70658329c0f81bd9db2e6ba259abbc8098d1e2366e8d0de18a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a16bb0c9e7a467c664a12ff594c22706d94f4534e1b719740606e9ebe5eee6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a78fbcedc1d9899bf82cbdc736d90c3f266e479705e16691c966a23d3dcea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc29da88bead5fe30754a9f8306cfbc6475e19a47922af8c5e79275fa42df5f"
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