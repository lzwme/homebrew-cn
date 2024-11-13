class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.3.tar.gz"
  sha256 "2647fb9f5b6bd7c17074a597aee40c04b6636dd92e4367d1bdcebd2453a34717"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb5cae29c24c7a24edb2852e526dfa1e8b640e5090898cb483c2bcc30a9cc59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb5cae29c24c7a24edb2852e526dfa1e8b640e5090898cb483c2bcc30a9cc59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5cae29c24c7a24edb2852e526dfa1e8b640e5090898cb483c2bcc30a9cc59e"
    sha256 cellar: :any_skip_relocation, sonoma:        "425c1bd3b451745680ef5e11cf5e1671ea54322f47a429ae060426c9fa71c136"
    sha256 cellar: :any_skip_relocation, ventura:       "425c1bd3b451745680ef5e11cf5e1671ea54322f47a429ae060426c9fa71c136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d41f1865af82ea37a2896cbe36abb56159c81dee87d357f01e2ded0eff0d3e"
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

    (testpath"config.yml").write <<~YAML
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
    YAML

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end