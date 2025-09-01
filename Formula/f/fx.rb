class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghfast.top/https://github.com/antonmedv/fx/archive/refs/tags/39.0.4.tar.gz"
  sha256 "e28b091c28a1f3408795337c6d5e01aa2162ebb75d4d6d950acb00911ffb5305"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e6480718cdf56f7c33125cd8fde2945a7c7c895eea73166d9e710ebfe98813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e6480718cdf56f7c33125cd8fde2945a7c7c895eea73166d9e710ebfe98813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11e6480718cdf56f7c33125cd8fde2945a7c7c895eea73166d9e710ebfe98813"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f069c971e4574e5dc0475ee0f16c281e7310531bdfe40ab23f5195870514ae5"
    sha256 cellar: :any_skip_relocation, ventura:       "7f069c971e4574e5dc0475ee0f16c281e7310531bdfe40ab23f5195870514ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee4a6fb4be7d0191bec202acc4c0997c1db58df46cd7079ab24cd15acff504c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end