class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.19.tar.gz"
  sha256 "3333126d231ba076de5097abeaf65233b17b257b36cb466a70e70c2b6f7dbfd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c3ea5c3c53aae1fc1ed07969ab0660fdf1aa7b1b6e84c6c427c86098d10b9e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cdd26776772e80461dca8b9e6dfdc532e9611a263c17c605f45965a31d8966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18a933a060e1dfc55145b2a42db383b9eadb3ece6b7e33d1d882359eb8d0130"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f69cac539d26168e7445fdb1760f42c2840149a081c704641d4bf987256131b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb216d629d7db1609906fa53f6ae5c34edcb340092e20a790aac1eb302ba1c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51487dead7acf40f0cc11a275493794b4f89d26ff8869d6d4c0b9809ef43bc5f"
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