class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.734.tar.gz"
  sha256 "e83c6708a0d8c82d6edf4cb5c80efdc9ca0cce07875d39190171029d96057093"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d3ab90fcb2a363ddb29f088c2429f0de50a9b25a802e4303089fe36833983f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a5fd83e572ca4e45205af215e5495bac1b6e49fb745865d10a5ab9c7bb5d6bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3281593f8c72fc22271aced0efb4b1730d7786757a0e943aaa6b3da0a4faeec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a88de6d0d2c4373ebf42e2db5e047aaa3d0d699c2ecad44fee01065a473d52"
    sha256 cellar: :any_skip_relocation, sonoma:         "53909f16172ae43c762f1dc2a01fc50144fda8313fc38e2af61b589e14f61678"
    sha256 cellar: :any_skip_relocation, ventura:        "1ccadf7e20a885daecf4a39913b0dcecb4ef0a5e2d75b6a6172f3af452905651"
    sha256 cellar: :any_skip_relocation, monterey:       "711d6e4081386e6bb275cfa2ca6e3c0c03fd47abdb76086e668e3e595f1bb1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6a46b25ba541d3fd35dc56dad303d2431eff31a65f90a1a074f1858fa58220"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMajorVersion=#{version.major}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMinorVersion=#{version.minor}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildPatchVersion=#{version.patch}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildShortCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildDate=#{time.iso8601}
      -X stackqlinternalstackqlplanbuilder.PlanCacheEnabled=true
    ]

    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end