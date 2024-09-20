class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.14.1.tar.gz"
  sha256 "990fa647d842943bee7fe5694d2c553bc10e9de51cf0421a3ea682c1194b6a22"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56bd1cb1c6026dee4d61a388f9c90e65d4f55edeeb4c8e3aa863211ba6c5ff0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78afc74a7034d6849ee7b1e12dc4547695b979f9fc127830b20c8a16be537378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02fe477aa5f9bb4343e67306db0a01a05ddb81cd95dd22800ccf71008cfc3061"
    sha256 cellar: :any_skip_relocation, sonoma:        "45662540a3757b2765fb140775b7bdd2eaa4005f20bfeba526e7b6d78812ba89"
    sha256 cellar: :any_skip_relocation, ventura:       "81de42dbbf70f36e19f799be47a4e99ecc018a64118c4fa58062d2c6f8b6e578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe5f7bb68c42b8f9a5c9deb355815d98e6f657a7c77f35fcc9dabd7b5f30263"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end