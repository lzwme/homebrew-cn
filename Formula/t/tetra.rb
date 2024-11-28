class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https:github.comciliumtetragon"
  url "https:github.comciliumtetragonarchiverefstagsv1.2.1.tar.gz"
  sha256 "420f9fde6196d1c35642415a488439a6000d45e6fe597f07e85166483b7a2bd1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce262401e99fc6013eb9520e06899c0a655086f161cff0fef3b61fc176de0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d35e936df3c76800ef772762936f22f40299e49f095b033ca0f9c6e569d2286c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "010b5a7e35eb3abd1608384abde348ad5f28f0d57a1df9fa7f955fcac9d6e477"
    sha256 cellar: :any_skip_relocation, sonoma:        "1865944c948f5669e304805e89c0f3c6c32010db7d83ac7fc66d6892670983a4"
    sha256 cellar: :any_skip_relocation, ventura:       "2c428411c056efe4dc6da7f44d792ac05d20252e9a589b0b5556abb1b92b82dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e7c47bacc953b74ffe4546221d4a68077e6c4b4567b8fba0eacf72097151c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumtetragonpkgversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"tetra"), ".cmdtetra"

    generate_completions_from_executable(bin"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}tetra version --build")
    assert_match "{}", pipe_output("#{bin}tetra getevents", "invalid_event")
  end
end