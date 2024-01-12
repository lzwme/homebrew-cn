class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https:autorestic.vercel.app"
  url "https:github.comcupcakearmyautoresticarchiverefstagsv1.7.10.tar.gz"
  sha256 "6cea71c718f824a38c1018982649882d46aa612538ecb8259b3c2e538f473efb"
  license "Apache-2.0"
  head "https:github.comcupcakearmyautorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d425620af7be7a8e74a2d09912d433b7463d2e9f60ac39e00cd0fcb252182ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dfdc9f18e3777b631a10b31e2135baaf83df897c4ade8e5916ddec875087c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82b1b90c8ba8b92aaecd9ec0b0f12c1c1ce2c63990e7ff799bee1a6e7697993f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5742b9f173b02a3381324f78bd50cbe5e81412a032f9ba59f7ea69c6dcde9583"
    sha256 cellar: :any_skip_relocation, ventura:        "a9bbbc055837c2a41c58e7c84a9b174d533f6b4dcf5417f1d67438746c764b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "092a09e3eb7421bcae7d9fb8d688c66e821e2a60d4442e31cc20e314bb33fcad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cddeca26fffd3fcbaa3f7d8b2a59336afeb4fb4623c08faba33b1c13b06c8c78"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, ".main.go"
    generate_completions_from_executable(bin"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath".autorestic.yml", config.to_yaml)
    (testpath"repo""test.txt").write("This is a testfile")
    system "#{bin}autorestic", "check"
    system "#{bin}autorestic", "backup", "-a"
    system "#{bin}autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath"repo""test.txt", testpath"restore"testpath"repo""test.txt"
  end
end