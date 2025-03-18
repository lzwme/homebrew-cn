class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https:github.comEhco1996ehco"
  url "https:github.comEhco1996ehcoarchiverefstagsv1.1.5.tar.gz"
  sha256 "d6883b1ecdf4551f0b8fcbc8863089de0c5971944d0d2fa778835fd2ec76cfe8"
  license "GPL-3.0-only"
  head "https:github.comEhco1996ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f18885bbcbafe2095ce0f0d3d7c180d8e2a646d69525a7528b38499ffa2ed065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a922799139ed0c48b58976708f27d3d59976c91f39db062720c3b502f70ec52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace45d76fd53671e7c3bbe1a75f7cf5b1e5c2098f5ba41c2a35ab10d71b050f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ba3e478b23911fc098632347f408b9cfc4a38e2a46f86c6d6c7ee3582aa4d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "321d48abbed4fd8b95819fe99bb469fd6003ffd8f1b2d5604cbbc61235edbf86"
    sha256 cellar: :any_skip_relocation, ventura:        "702dad8245708582ae80e98b18e421cfabf625446a7367c0f91f59ce9fb4ea40"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6e8ee224725f9d7d5fe78ebf9db83950b878a8432856846c54cbd639510678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc15a224177b50b7f245e3071f6d1116e77f4e9317424decedb3b38a4d346e6"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comEhco1996ehcointernalconstant.GitBranch=master
      -X github.comEhco1996ehcointernalconstant.GitRevision=#{tap.user}
      -X github.comEhco1996ehcointernalconstant.BuildTime=#{time.iso8601}
    ]
    # -tags added here are via upstream's MakefileCI builds
    tags = "nofibrechannel,nomountstats"

    system "go", "build", *std_go_args(ldflags:, tags:), "cmdehcomain.go"
  end

  test do
    version_info = shell_output("#{bin}ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run nc server
    nc_port = free_port
    spawn "nc", "-l", nc_port.to_s
    sleep 1

    # run ehco server
    listen_port = free_port
    spawn bin"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{nc_port}"
    sleep 1

    system "nc", "-z", "localhost", listen_port.to_s
  end
end