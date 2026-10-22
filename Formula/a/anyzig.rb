class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://ghfast.top/https://github.com/marler8997/anyzig/archive/refs/tags/v2026_10_20.tar.gz"
  sha256 "36ad6d7304e755347de26cba7423b4bcef8c9a35fb55e32a1c67baf2cbadd479"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c2efa73f5e36b58fab5b8fc74e3883f6fe30d38da3157896f0548e0101a630f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3dcc69817eab9f039b7ad80a62b17311342857b534ab380daa5f3e06a1617af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8822caedeb7b0d34db039bb4c3847e9ad8c02775613e08da2e35093cfe0eed8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0e33ea195631afd98a412bf1783c525bff9fe63487412cefb9fd101e868632b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e7c636b367dbf3c5e089ac3a3f914a26241b922049c3d14ec5ee03f0ac91a393"
  end

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end