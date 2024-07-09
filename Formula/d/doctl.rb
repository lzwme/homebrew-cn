class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.109.0.tar.gz"
  sha256 "e1d6365b0e44ce1e539d9e8ffa232a5016dc2b147d85971974cf62f3fe41f64e"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "050cab114e373822d5a557697be4841e7ee1cbbf0dbbdfb1b964ff7da2b2bb4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b550d2a2485aca9f781d6a6ad8cafd2d5d7095791c733b6668a21d81a582893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e650117fa86faf38de831f7df16bd33e02cf22a0a6bbe65ff3ef5e28c8c844a"
    sha256 cellar: :any_skip_relocation, sonoma:         "557bb22c5c253056ca44262997b5fd59820b74b0ed95a7bb219e3ea8b13e0918"
    sha256 cellar: :any_skip_relocation, ventura:        "0e64e0a89f24ab007199de28f9041915918ba2f31e5c8a1cde695f5728284c98"
    sha256 cellar: :any_skip_relocation, monterey:       "5f7fd9df193660161f5b1a408c679ddea26fa078ecaac7846bc9538bbd669182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dc74af58247997104ec0c1aacd5aef5ea9c7ec5d47b9b91c89831f8ace7bb4"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end