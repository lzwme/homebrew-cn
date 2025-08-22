class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghfast.top/https://github.com/antonmedv/fx/archive/refs/tags/39.0.2.tar.gz"
  sha256 "ea1dbfd760f0ab664dba9bc4d49f4426b7a01f5beb70896527365321e997c57c"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b115ab29802931cf05ed7c2d8b8713e3f7c45b25f4d54931e42a37cff38295c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b115ab29802931cf05ed7c2d8b8713e3f7c45b25f4d54931e42a37cff38295c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b115ab29802931cf05ed7c2d8b8713e3f7c45b25f4d54931e42a37cff38295c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d479f3eda30bc063f99102d11dcfd817290a0e90a69b487761cee973ecbf8c74"
    sha256 cellar: :any_skip_relocation, ventura:       "d479f3eda30bc063f99102d11dcfd817290a0e90a69b487761cee973ecbf8c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d7afccf428de476f45e6733fe6781234ea9935b6a7c75709264ef350624f68"
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