class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "6c7a78a86713638510343253f8b248f13b156679e2003bc8584f3c3069c93467"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df9ea314dd7a3d2ea02ed3fb71673780ce80660254d3934f762f4710dd15e822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df9ea314dd7a3d2ea02ed3fb71673780ce80660254d3934f762f4710dd15e822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9ea314dd7a3d2ea02ed3fb71673780ce80660254d3934f762f4710dd15e822"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d04d8f5298ba487a735aad144a8804b8bfaf5bbcd8adb1118e9ca4f4bb2291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f92e08354f030a708e72c0ccf6219f6f519fb8b5406f7cc2bf27a9c34145d782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ee01e5527562ec304d08e50b255c9405f679e9e31bd68a094d77cf498e47d4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end