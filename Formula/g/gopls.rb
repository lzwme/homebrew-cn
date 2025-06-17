class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https:github.comgolangtoolstreemastergopls"
  url "https:github.comgolangtoolsarchiverefstagsgoplsv0.19.0.tar.gz"
  sha256 "31fb294f11d5a939a347c4c62ff2b9a92d739a5feab73e7b795bb041367da0c4"
  license "BSD-3-Clause"
  head "https:github.comgolangtools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0180b09330b40d0bb58174a6411808a542ce4086a0b19b3c6d6a79774a8087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0180b09330b40d0bb58174a6411808a542ce4086a0b19b3c6d6a79774a8087"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d0180b09330b40d0bb58174a6411808a542ce4086a0b19b3c6d6a79774a8087"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d8dc48ae991fae917c13027521584462b10bf398babbf3ba7d53261a2f931f2"
    sha256 cellar: :any_skip_relocation, ventura:       "8d8dc48ae991fae917c13027521584462b10bf398babbf3ba7d53261a2f931f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07932bc79b818b1f1beb0e5f81d4c8f019382c9414ab6e71e672efb12db8e6c1"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}gopls version")
  end
end