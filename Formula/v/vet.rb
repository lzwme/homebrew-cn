class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "9e34169f37784728656affffb3e67a9b11d4b0bb622b410df620392ab667667f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cedd6c2250960223fc27e0b9b0b8218602159dc815feb6396d09273c1ab5b170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812599e182f891f12fad3ea2e979d611c3e2b1c3bb8091e608bf779488ea7dbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de8b728265d1af140df2128520c1e8d424a9dbc89874d3dcd5c630552877473c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fddef692102ad464219ae8a8a143c680f6c37d59d6f7ba5bc51e4c383255c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d851da94bad3d8ee76e9aa78c8d240409ba546dc514861c0ee54b8032c5b930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1996adea4152813c4b5c6a450894948582abff3b5c91ecfb02a9c9907e58a0c7"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end