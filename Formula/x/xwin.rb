class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https:github.comJake-Shadlexwin"
  url "https:github.comJake-Shadlexwinarchiverefstags0.6.1.tar.gz"
  sha256 "c832b596aba957f5de7f576520352166b58e89a51f2484f3b98e7aa4b9c151e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9857f1a77163eab2a6ce3419bd9c1f32f083862746b3db2b0cf5259aa269874"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cccbf0fa8a0986b1dd8a37ab2abd60c9efe8675459e2644ce43a3e7eb6718f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f26d88c16466d373a14309ce6b4930a62043c99ee5f7dff1cd61462cf3ae97c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8de35f8205a8ccc2ac4807cd650d6b132099caca6fa2e1d3639a3d8529250aaf"
    sha256 cellar: :any_skip_relocation, ventura:        "bc92dc0859390af184ef37fb7cc56ad695082f878b5e0956cf7a6cb3de3895c0"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0ac24ec4f4b43aceae9dba8a842e0c85404a092c06c2364d3e938f68526053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5e02a782c8c43f1a9273d6aabdd25d0502ccbf4694a7538293929ddd44fe394"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath".xwin-cachesplat", :exist?
  end
end