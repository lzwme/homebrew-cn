class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https:nmstate.io"
  url "https:github.comnmstatenmstatereleasesdownloadv2.2.42nmstate-2.2.42.tar.gz"
  sha256 "ca1a1db4df29043cecadb705535c16ac3a19d484c5924b78f2ffd40694891390"
  license "Apache-2.0"
  head "https:github.comnmstatenmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a24fef699129063c836a235da8469c673702c8016227f4d67495631e64a4bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3734bcae262aedff626fadde0742aae1bf323a1e5224529124d971538346982"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2edbf59b1594e54d90effb4a7286194cecb915b187ba9ed53454e428fb90d5cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8197fe2b146f38d04a0bff498854dada75c745e56b3732675be0a7284e833959"
    sha256 cellar: :any_skip_relocation, ventura:       "2bdb25f9adfc399727a0e1b59cd591253fc027c37fe479b25b3480de067832a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696df850d082d0320d79c562e0d2a0067745767b8c680bfc49bde725535d2595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a616de452d02a243a04eba18b028dd90ca67ec0f8286d5367d6ed3613e8f1da1"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "srccli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}nmstatectl format", "{}", 0)
  end
end