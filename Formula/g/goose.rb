class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https:pressly.github.iogoose"
  url "https:github.compresslygoosearchiverefstagsv3.23.0.tar.gz"
  sha256 "f536522a4575cf9c74f32c3f7a33c4920d2740d8a22da59f36a90bc369cbe199"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6c79a1f864a6bfcd5faca5d898b54044470f5c00b701ea80bba61276d0da5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a8e7f8ee89d2f4f18f4a27423fcc5c5adcd3c9d7f73b877b65c15d73010fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf5281cab7492223aba7da3548ae2735577b76312f84d633abcc53f6b172576c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2d4031e4d136a7f2e1075d44b14ce4716da017fce39cc64843f7d13c7b5234"
    sha256 cellar: :any_skip_relocation, ventura:       "77c9921ff1df6a1ac78c125fe78578fffddf1ce1d2904fd188077a4dfd933e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855d933cfc8dc11033b74cad9881410f64bbcd14249dda7c8e10edeb367df8d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), ".cmdgoose"
  end

  test do
    output = shell_output("#{bin}goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}goose --version")
  end
end