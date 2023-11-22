class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://ghproxy.com/https://github.com/safedep/vet/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cde854bf9e4dbb0fc3eadd31af9c24031dfeb31444d23db8fe5ff82fd582902c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "073fbf1fd6ad88ef5a94f0ae1300a30810e64e1c74def4dcb08510d45c676d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "856935b9bcef59f9f7961f899e24c05834d50037f3fbae6084bba3f5a96cf63a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f18cd64ded5be8d5dc4eca51dd319bbd67240f6597f69fcc2d8c1e8f4e902cf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccb2d76b87de8978f3dcb7cbcc53b793a21128b81c3e97cc7a723644131b4d7b"
    sha256 cellar: :any_skip_relocation, ventura:        "de918c5964e1c469ec0b62d720f357215b9e73e4c8da2cc773bf1c92e2903ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "505b5d73128523bf7e7e6469bc1fe2449603e862417026c9c4382254de39f1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92c4a2c636d748b03d50665447679b90f79f2f5dc2c7f4df1483d271a18bc06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end