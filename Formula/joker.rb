class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://ghproxy.com/https://github.com/candid82/joker/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bf82b2f5deeb5f449eee127c2173a89dfff53da6c9765d0da312bf730395efd4"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "801c55702695aea890dbf8e37fe8dddcd66f037ca7e6c5ebd4f61e124be9d7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "429f0300ad38dd5d7bf0a070a599acb5de4bbc712f927af4d2525ee46d04fb52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bc35eb0114c862ad74a0d79bcd9c43e282e985ea49acde04935727837e319fb"
    sha256 cellar: :any_skip_relocation, ventura:        "051f5725e4614ec789311b65c0f8d281935018db3c9bca23336cff7638a00114"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0b4d2c1db012edf121566349950b167fcfaa4166f488e91667c27e739be280"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1c419309659ed0e83454ca3c62d0e77c3866f7a6e466e8a51fb4113c4a2cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b1b3ae255d60a462958448c1c51e3c45a0ece98c11b0ed53032b4b28a22a15"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end