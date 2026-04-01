class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "3f19abbaa1bcd5f89035def0191a76fb4add895ca40d4be90fd942dcbc3eb11d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cff75970d14e701e12138e5c72f03c89609cad0cefc823f49296c28450f4a724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5d0ec66167dffe249ea0306761a6696581d5b2c82d0c11f60a13788aa56bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a5a3cce9b646576cd7f88923b1002c2210054dffc25b045c54e9662b7db06df"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d37e3d6984baf5bdf48194d6f8752d1e71bd8cdc536ea6077f17fb021bffc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a47c0e2128e3268df34e71f9c80f1faad73a7a69513a548f68a9c91f324d9d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f21586e322beebbce3b14ffdea193c348047c57dc63e1c9acb85ba9434801fb"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end