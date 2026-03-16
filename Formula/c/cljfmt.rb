class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.16.2.tar.gz"
  sha256 "2c8f71c4c9495bef1b8037d6da7e494f919c9c324e604dca626855e6074119ee"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4a0c407a98ad9c2cc49f1cd323087a0a485c8ed6e6b9afe6d46e7ee0109e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b2acfb6701c227e733d8ea59a26daf93264b9cd82dc7f89f0be8140b5bc851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d073d8932c4f7c9778e7d80fb2ac749a89a38c6bef7bd7d6b8fc4e0cda16717"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4837f6a670df473495375f9c095460e9390500e8131652f8e22c72b7773c271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc1fc67a596fc7bd2b55e08eb0776931f278ba7892c95277bc891249065b682c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9550e4d3a86e53071ffd350f15e772f8dafd1881f7a249d9d4faa30c062857"
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