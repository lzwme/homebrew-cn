class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.15.1.tar.gz"
  sha256 "9c1b265184f6d2906e2a11c156885affc4139adfaeaef1594e57e8b086f0626e"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad486dc4a52a17e9a603a486b6e2e6d6cc933171ceae1a7469fac38382c444e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d697ba9d43c1cf513e274146db46e4fdaa764a26907b08c141c78d962f767915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932a97d427511f401837dddaf26c2f9c2938cb86cf71ab7b1b980fca6c6949b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "293612cd7f7e5a87dd33e3eb40737899bcb1cbdf02ac58590a785c44f429ebca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a67c04704546a9fca80ef7a346a972e35679e44be9c804f219afdc99a0491c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759bd00a6ed9dddde60524f40ed9ec91c8f34f61a136113637894bdc57ae4a09"
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