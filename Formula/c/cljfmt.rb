class Cljfmt < Formula
  desc "Formatting Clojure code"
  homepage "https://github.com/weavejester/cljfmt"
  url "https://ghfast.top/https://github.com/weavejester/cljfmt/archive/refs/tags/0.14.0.tar.gz"
  sha256 "a367992b9a9e0ad3eb1386af441a8a0739841c9946082acc288ab392109d5d6c"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321e2ae797fc2aa9693dac91bc4c754bc1d10e813d14926dfde8f9e0e870ec6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30e91b6a283c543a50ba81217c0d0ec78c25e105f3c66926f411ced97f38e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c7c5da4da326ae40ba4dd620be71c6d311f91c540857a81cf66c3537ac5f42"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6b6c8df15910627fa32fd8b81481a320fa33ceef93fb9d98cd70ea1026bd7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08439ce8055140a5216284ef4cb208c4f0b1c306007e8a0023d18fff316b994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420ee07ddfdd0538daf17c92ab3d51af0d2ddeaf2a63fdad9a1b62bf6115d0f0"
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