class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://ghfast.top/https://github.com/google/yamlfmt/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "d4abdb4f10e1c55b513a94584864037515937e16611f9de32871c4a2f477f65d"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65ffc4a7610baa4e895f64635fcb99c64ece4ea3a180ecc3b1072d88b1bf5b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65ffc4a7610baa4e895f64635fcb99c64ece4ea3a180ecc3b1072d88b1bf5b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ffc4a7610baa4e895f64635fcb99c64ece4ea3a180ecc3b1072d88b1bf5b6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e041a16d72257eadcf18693155857b6ad5792dd6521391f7147bc4b25cec1949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e725618652ff821f28b17aff4d4ecdb7598746ef3f56b992ec99288b3fb437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75512acead1c9f88c6ee9181da7904fac5c44670ac67f4da1e176aedcbe2a81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/yamlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfmt -version")

    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end