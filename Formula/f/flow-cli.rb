class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.17.0.tar.gz"
  sha256 "054c6cf3938d6b5b7225e248565d30f83a5d39c38e2834daa6e1008eb31eef03"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "153f70f32bfe381defa484ee02c5fffd3fb3accbd17283932a07004a260e4141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb04bdc719eb92020cdb58064824804d8ee406debe022ae8dc449b0bcf2361b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f4ddb01fb9d15e585ec9072b7323cd3d0cbee940171c4d360a1c412dae4aa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c9fb88a131e4fa127c082308fc29f26ce7a7b395dc511f127f4ab0797e700bc"
    sha256 cellar: :any_skip_relocation, ventura:        "a3caee96767da986d3abef7f91641090c53ff33477366581d4fb4b193ba22f3e"
    sha256 cellar: :any_skip_relocation, monterey:       "118a4c88afa3427b9d9d1fd698d9206c142e8ad8b0a9e4e97f4de68017b3f374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35536eca9072783d2aaf65870be06b37334b8ab0e3661413aa4e3ba99ed81941"
  end

  depends_on "go" => :build

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}flow", "cadence", "hello.cdc"
  end
end