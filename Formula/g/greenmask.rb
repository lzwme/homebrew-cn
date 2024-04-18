class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.1.10.tar.gz"
  sha256 "3d5732cff5acb2db1dbf9ac56206500fbf022cedeed21c0b58de0c752f684d52"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faf4efee4ea9fe5b6e8225e9dcd734d927fcb46f72547c064b3218ad9b8c6207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acadac1732159bc8129eb3bbaa2c04ccdc06e431b1d0e6e2f18ca6314cee2cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "473d3794234eb942b5f90b52472d03f1e8bf8f06fce83e19fc3b52a0b739c7c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2430cc200de3279f03442815840df012d4012455540ede6c0454a8d234e8c79"
    sha256 cellar: :any_skip_relocation, ventura:        "479931d088b31503925556a7909729e07a6d00862534167d98de2fe1a18dba42"
    sha256 cellar: :any_skip_relocation, monterey:       "7eff534ab4ec99df60cc1af6d8acd0c839fa4b5beed2a4c2d475719ec998319a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26bd9fe1f35803cd6347b20b59e6c8684a1c94f77f6c4652a2489a7149c61ea0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~EOS
      common:
      pg_bin_path: "usrlibpostgresql16bin"
      tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    EOS
    output = shell_output(bin"greenmask --config config.yml list-transformers")
    assert_match "Generate random uuid", output
  end
end