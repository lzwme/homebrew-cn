class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://ghfast.top/https://github.com/regclient/regclient/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "22020b663c04e7a740cb6b65b58b1651a9c6dc61069ab7e51eb45325bcc8ea9e"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539bee7039acb2ac9fb3eb9a0ff755f2d7348bc9b03f1c1a6fe4b0a6f4373bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539bee7039acb2ac9fb3eb9a0ff755f2d7348bc9b03f1c1a6fe4b0a6f4373bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "539bee7039acb2ac9fb3eb9a0ff755f2d7348bc9b03f1c1a6fe4b0a6f4373bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1845439cadcf263e42708ca52240b939c431956d46f71221bbe847308a9dea0"
    sha256 cellar: :any_skip_relocation, ventura:       "d1845439cadcf263e42708ca52240b939c431956d46f71221bbe847308a9dea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba9003aab90173418bd0a4ded783692cdb7a177129c279a24a21144a54f6c019"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "docker.io/library/alpine:latest", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end