class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https:www.descope.com"
  url "https:github.comdescopedescopecliarchiverefstagsv0.8.9.tar.gz"
  sha256 "05b55018ab56ed06175c17f14055cef6994e3715c0bb79411c566b678fd9e547"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ace8c3e696368ff9ecd38df3529695c27acb1b1d7da6acbc0b959feddc7058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ace8c3e696368ff9ecd38df3529695c27acb1b1d7da6acbc0b959feddc7058"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78ace8c3e696368ff9ecd38df3529695c27acb1b1d7da6acbc0b959feddc7058"
    sha256 cellar: :any_skip_relocation, sonoma:        "677bad1470b3aa9fdc1ab6ecdb86d008ab6d6abc14480b4e21d6bbacba2e1df9"
    sha256 cellar: :any_skip_relocation, ventura:       "677bad1470b3aa9fdc1ab6ecdb86d008ab6d6abc14480b4e21d6bbacba2e1df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f14fd9ad06f75806da26e799678b8533f61e41140efafe341343912caba8ba1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}descope audit")
    assert_match "managing projects", shell_output("#{bin}descope project")
    assert_match version.to_s, shell_output("#{bin}descope --version")
  end
end