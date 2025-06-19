class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https:fx.wtf"
  url "https:github.comantonmedvfxarchiverefstags36.0.4.tar.gz"
  sha256 "ad4de8252a2e9401ddd69577940d707caf22ef5ae833dc55818860163c542056"
  license "MIT"
  head "https:github.comantonmedvfx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e67ca3e7d14b68ce85714d502c58fd02871fce850344b8d7d77ac2709e615c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e67ca3e7d14b68ce85714d502c58fd02871fce850344b8d7d77ac2709e615c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e67ca3e7d14b68ce85714d502c58fd02871fce850344b8d7d77ac2709e615c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "01991bd17ab5fb88622d57ce7f17aa44c7fd74851b50509d6f4b720a58a107cd"
    sha256 cellar: :any_skip_relocation, ventura:       "01991bd17ab5fb88622d57ce7f17aa44c7fd74851b50509d6f4b720a58a107cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ed00156edae0e2de5b99242b51f4d428ad390e82f05b7c8cd719f4f918ad61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}fx .", "42").strip
  end
end